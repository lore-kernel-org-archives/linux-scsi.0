From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Problem with aacraid driver in 2.5.63-bk-latest
Date: 14 Mar 2003 14:57:59 +0000
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1047653879.29544.9.camel@irongate.swansea.linux.org.uk>
References: <20030228133037.GB7473@jiffies.dk>
	 <1047510381.12193.28.camel@markh1.pdx.osdl.net>
	 <1047514681.23725.35.camel@irongate.swansea.linux.org.uk>
	 <3E6FC8D6.7090005@torque.net>
	 <1047517604.23902.39.camel@irongate.swansea.linux.org.uk>
	 <1047570132.30105.7.camel@markh1.pdx.osdl.net>
	 <3E711194.9010505@redhat.com>
	 <1047597729.30103.386.camel@markh1.pdx.osdl.net>
	 <3E71134F.5060404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <3E71134F.5060404@redhat.com>
To: Doug Ledford <dledford@redhat.com>
Cc: Mark Haverkamp <markh@osdl.org>, dougg@torque.net, Christoffer Hall-Frederiksen <hall@jiffies.dk>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux aacraid devel <linux-aacraid-devel@dell.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2003-03-13 at 23:25, Doug Ledford wrote:
> Mark Haverkamp wrote:
> > Then it sounds like the aacraid driver could set cmd_per_lun to a small
> > number like one since the real queue depth will be set later in
> > aac_slave_configure.
> 
> Yes.  And since the driver doesn't support anything other than drives to 
> my knowledge, 1 would be appropriate.

It supports both disks and non disk devices. Disks are mapped onto bus 0
and are driven via firmware smarts as logical devices, non disks are bus 1
and there it behaves mostly like a scsi controller
