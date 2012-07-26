From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: virtio(-scsi) vs. chained sg_lists (was Re: [PATCH] scsi: virtio-scsi:
 Fix address translation failure of HighMem pages used by sg list)
Date: Thu, 26 Jul 2012 10:56:33 +0300
Message-ID: <5010F831.9030300@panasas.com>
References: <1343204966-23560-1-git-send-email-senwang@linux.vnet.ibm.com> <500FB1DE.1000100@redhat.com> <500FBAE8.2050107@panasas.com> <500FBF37.50603@redhat.com> <500FE7D2.7070101@panasas.com> <500FEB63.3000709@redhat.com> <500FF412.3090600@panasas.com> <50100014.2010109@redhat.com> <50101091.5090909@panasas.com> <50103043.5050508@redhat.com> <50104614.3080002@panasas.com> <501051DF.5040907@redhat.com> <50105F60.8050707@panasas.com> <5010F07E.7050506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5010F07E.7050506@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Wang Sen <senwang@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, JBottomley@parallels.com, stefanha@linux.vnet.ibm.com, mc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
List-Id: linux-scsi@vger.kernel.org

On 07/26/2012 10:23 AM, Paolo Bonzini wrote:

> 
> In the meanwhile, we still have a bug to fix, and we need to choose
> between Sen Wang's v1 (sg_set_page) or v2 (value assignment).  I'm still
> leaning more towards v2, if only because I already tested that one myself.
> 


It's your call, you know what I think ;-)

I Agree none of them are bugs in current code, they will both work
just the same.

> Paolo


Please CC me on the "convert to sg copy-less" patches, It looks interesting

Thanks
Boaz
