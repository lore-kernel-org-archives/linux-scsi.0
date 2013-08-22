From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] scsi: fix the build warning
Date: Wed, 21 Aug 2013 18:17:51 -0700
Message-ID: <1377134271.12003.15.camel@joe-AO722>
References: <1377132262-15744-1-git-send-email-zwu.kernel@gmail.com>
	 <1377133329.12003.9.camel@joe-AO722>
	 <CAEH94Lhh11+zFHsRNDXoyxQfndxDRMcVvLnZDXQLw5cyaavUJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAEH94Lhh11+zFHsRNDXoyxQfndxDRMcVvLnZDXQLw5cyaavUJw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>, linux-kernel mlist <linux-kernel@vger.kernel.org>, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2013-08-22 at 09:05 +0800, Zhi Yong Wu wrote:
> HI,

Hi.

> If you'd like, you should draft one patch for this warning.

Not for me.

I don't get this build warning in the first place and
I think the scsi_debug file is quite old and probably
doesn't need to be changed at all.

I think scsi_debug_guard could be set to a negative
value and then the csum will always be -1.

Dunno if that's a good thing.

Anyway, just a suggestion, do what you want with it.

cheers, Joe
