From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/4] libata: consolidate ata_dev_classify()
Date: Sun, 07 Sep 2014 13:24:47 +0200
Message-ID: <540C407F.5030305@suse.de>
References: <1406706911-79510-1-git-send-email-hare@suse.de> <1406706911-79510-2-git-send-email-hare@suse.de> <20140905234241.GH15723@mtj.dyndns.org> <540AC41F.8020506@suse.de> <20140906125227.GA29401@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20140906125227.GA29401@mtj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-scsi@vger.kernel.org

On 09/06/2014 02:52 PM, Tejun Heo wrote:
> Hello,
>
> On Sat, Sep 06, 2014 at 10:21:51AM +0200, Hannes Reinecke wrote:
>> Well, yes, in principle. I was looking into that, too.
>> But then I figured that moving to ata_taskfile would be a major over=
haul for
>> libsas, which would be quite beyond scope here.
>> And all for a puny little patch.
>
> Hmm?  Just allocate a ata_taskfile stuct on stack when invoking the
> function.  The change would be a lot smaller actually.
>
Which was actually my first attempt, but then I figured I'd be
increasing the stacksize in doing so.
But sure, if you're okay with it I'll be redoing the patch.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
