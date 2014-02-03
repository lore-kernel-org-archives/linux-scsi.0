From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: mpt2sas driver barfs when force removing a drive on 3.13.1
Date: Mon, 3 Feb 2014 09:24:09 -0500
Message-ID: <20140203092409.63ffd9a0@jlaw-desktop.mno.stratus.com>
References: <52EC60C3.1080103@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <52EC60C3.1080103@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
To: prometheanfire@gentoo.org
Cc: Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, JBottomley@parallels.com, linux-kernel@vger.kernel.org, kernel@gentoo.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 31 Jan 2014 20:49:39 -0600
Matthew Thode <prometheanfire@gentoo.org> wrote:

> I decided to pull a drive while it was in use out of laziness (it was
> open via luks, but not in actual use).  Got a fun trace as a result.
> Just thought you'd like to know :D
> 

Hi Matthew, 

The first trace looks a lot like what I see on mpt2sas driver removal
[1].  I posted a suggested fix back in Dec [2], which you might try,
however it is not reviewed at this point.

[1] http://thread.gmane.org/gmane.linux.scsi/86237
[2] https://github.com/joe-lawrence/linux/compare/scsi_transport_sas_sysfs_warning.patch

Regards,

-- Joe
