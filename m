From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [BISECTED] Re: [BUG] Linux-2.6.31-rc1 Fails To Recognize Some USB Disks
Date: Sun, 26 Jul 2009 22:43:47 -0400
Message-ID: <yq18wiakfq4.fsf@sermon.lab.mkp.net>
References: <4A4472DF.1050900@turknet.net.tr>
	<yq1zlbrn2rj.fsf@sermon.lab.mkp.net> <4A4878AC.3050208@turknet.net.tr>
	<yq1fxdji03l.fsf@sermon.lab.mkp.net> <4A69932E.90906@turknet.net.tr>
	<yq1fxcmnpqa.fsf@sermon.lab.mkp.net> <4A69D093.8020108@turknet.net.tr>
	<yq1hbwykj80.fsf@sermon.lab.mkp.net>
	<20090727020611.GC3711@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755778AbZG0CoP@vger.kernel.org>
In-Reply-To: <20090727020611.GC3711@parisc-linux.org> (Matthew Wilcox's
	message of "Sun, 26 Jul 2009 20:06:11 -0600")
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Tarkan Erimer <tarkan.erimer@turknet.net.tr>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Matthew" == Matthew Wilcox <matthew@wil.cx> writes:

First let's see if I actually interpreted the responses correctly and
that this fixes the issue.

Matthew> and the sd code seems to check for that.  So what bug are you
Matthew> papering over here?

The USB drive in question appears to go tits up when we send it an
extended inquiry.  I contemplated adding a BLIST option but we really
only need EVPD to access pages 0xB0 and 0xB1.  The Block Limits page
appeared in SBC2 so I'm just trying to play it safe.  And hopefully fix
Tarkan's problem in the process.

-- 
Martin K. Petersen	Oracle Linux Engineering
