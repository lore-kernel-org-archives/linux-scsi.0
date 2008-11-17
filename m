From: Frans Pop <elendil@planet.nl>
Subject: Re: extra bytes written to SATA DVD drive on kernel 2.6.23 till 2.6.24.2
Date: Mon, 17 Nov 2008 09:18:08 +0100
Message-ID: <200811170918.10516.elendil@planet.nl>
References: <200802252005.22663.gml@inode.at> <E1JXic1-0000Yo-K8@faramir.fjphome.nl> <4920DF5C.3030400@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754957AbYKQISZ@vger.kernel.org>
In-Reply-To: <4920DF5C.3030400@gmail.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Gerold Jury <gml@inode.at>, efault@gmx.de, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, vsu@altlinux.ru
List-Id: linux-scsi@vger.kernel.org

On Monday 17 November 2008, Tejun Heo wrote:
> Can you guys please add yourselves to bz#10743?
>
>   http://bugzilla.kernel.org/show_bug.cgi?id=10743
>
> Please test 2.6.28-rc5 as it contains sata_via changes (TF access
> needed specific workaround) and see whether the problem is fixed and
> report on bz.

I cannot really help here. I never saw the problem myself, but just 
thought I saw some pattern in the breakage that might provide a clue.

Sorry,
FJP
