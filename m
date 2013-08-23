From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/9] target: Add support for EXTENDED_COPY (VAAI) offload emulation
Date: Fri, 23 Aug 2013 08:33:46 -0400
Message-ID: <yq17gfc60yd.fsf@sermon.lab.mkp.net>
References: <1377224821-23422-1-git-send-email-nab@daterainc.com>
	<521741B7.9020904@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <521741B7.9020904@interlog.com> (Douglas Gilbert's message of
	"Fri, 23 Aug 2013 13:04:23 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: dgilbert@interlog.com
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, Roland Dreier <roland@purestorage.com>, Zach Brown <zab@redhat.com>, Kent Overstreet <kmo@daterainc.com>, Theodore Tso <tytso@mit.edu>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Doug" == Douglas Gilbert <dgilbert@interlog.com> writes:

Doug> The SCSI opcodes associated with it (0x83 and 0x84) have been
Doug> renamed THIRD PARTY COPY OUT and IN, and

Where did you see that? My SPC still has EXTENDED COPY.


Doug> Confused? I certainly was.

Yeah, this is UNMAP all over again, just 100 times worse :(

Anyway. Excited to see nab posting the patches! My copy offload code
from the spring has been getting stale both in the T10 and the kernel
sense. But at least we know what I'll be working on next week :)

-- 
Martin K. Petersen	Oracle Linux Engineering
