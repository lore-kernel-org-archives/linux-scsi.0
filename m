From: Hannes Reinecke <hare@suse.de>
Subject: Re: mptsas driver cannot detect hotplugging disk with the LSI SCSI
 SAS1068 controller in Ubuntu guest on VMware
Date: Fri, 27 Oct 2017 16:53:13 +0200
Message-ID: <486fc58e-ac8f-cb48-4757-0b9a8e1c2121@suse.de>
References: <CA+eFSM1aJRYs__pwtz+8E0TFOeKuKpHoiOkX6Wmm_2HMT1ut5A@mail.gmail.com>
 <1ad520f6-a1d8-5ce7-ee74-83edfdbfd39b@suse.de>
 <CA+eFSM24pwY0ViCiUqvzNDJa-Q0h0+XnEFF-gesKfBcEVKyLgQ@mail.gmail.com>
 <CA+eFSM3z=LdO78seoZtpAc7U7ec=Gzrm5ej76TafoM6Ea1Ektw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+eFSM3z=LdO78seoZtpAc7U7ec=Gzrm5ej76TafoM6Ea1Ektw@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Gavin Guo <gavin.guo@canonical.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 10/27/2017 04:02 PM, Gavin Guo wrote:
> Hi Hannes,
> 
> Thank you for looking into the issue. If there is anything I can help
> to test the patch? I appreciate your help. Thank you.
> 
If you had checked linux-scsi you would have found this patch:
'[PATCH] mptsas: Fixup device hotplug for VMWare ESXi', which I guess is
already scheduled for inclusion in 4.14.
Anything else I could help you with?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
