From: "K.R. Foley" <kr@cybsft.com>
Subject: Re: 2.6.9-rc3-mm3 fails to detect aic7xxx
Date: Thu, 07 Oct 2004 15:13:29 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <4165A369.60306@cybsft.com>
References: <1097178019.24355.39.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S267679AbUJGURg@vger.kernel.org>
In-Reply-To: <1097178019.24355.39.camel@localhost>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Andrew Morton <akpm@osdl.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Dave Hansen wrote:
> I just booted 2.6.9-rc3-mm3 and got the good ol' 
> 
> VFS: Cannot open root device "sda2" or unknown-block(0,0)
> Please append a correct "root=" boot option
> Kernel panic - not syncing: VFS: Unable to mount root fs on
> unknown-block(0,0)
> 
> backing out bk-scsi.patch seems to fix it.  I believe this worked in
> 2.6.9-rc3-mm2.
> 
> -- Dave

While I can't verify that backing out bk-scsi.patch fixes it for me yet, 
I can verify that I get the exact same error trying to boot this kernel. 
I too am using the aic7xxx.

kr
