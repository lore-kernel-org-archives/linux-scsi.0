From: Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH]: HotSwap SCSI in Soft RAID1 (scsi_rescan)
Date: Sat, 21 Sep 2002 09:56:54 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020920235654.GA25521@krispykreme>
References: <A5974D8E5F98D511BB910002A50A66470580D1EC@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <A5974D8E5F98D511BB910002A50A66470580D1EC@hdsmsx103.hd.intel.com>
List-Id: linux-scsi@vger.kernel.org
To: "Cress, Andrew R" <andrew.r.cress@intel.com>
Cc: linux-raid@vger.kernel.org, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, 'Mads Peter Bach' <mpb@hum.auc.dk>, Jens Arnfelt <jens.arnfelt@ab-innovation.dk>


Hi,

> The premise I had was that this should take place automatically when a scsi
> device is hot-inserted, rather than requiring intervention and knowledge
> from the sys admin.  In short, it should work more like a hardware RAID
> solution would.

It would be great if we could also have a SCSI Enclosure driver to
handle insert and removals. This could all be in userspace (using the SG
ioctl). In fact I played with some code from Matt Jacob a while ago and
hacked it about to do scsi-add-single+raidhotadd and
raidhotremove+scsi-remove-single.

Do your drive cases support SES?

Anton
