From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/4] sd: Optionally attach to ZBC devices
Date: Wed, 30 Jul 2014 08:41:55 +0200
Message-ID: <53D893B3.6020407@suse.de>
References: <1406645117-53088-1-git-send-email-hare@suse.de> <1406645117-53088-5-git-send-email-hare@suse.de> <20140729171414.GA1060@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20140729171414.GA1060@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hsh@infradead.org>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/29/2014 07:14 PM, Christoph Hellwig wrote:
> On Tue, Jul 29, 2014 at 04:45:17PM +0200, Hannes Reinecke wrote:
>> ZBC drives are close to disk devices, so sd.c is well
>> suited as a testbed for ZBC devices.
>> This patch introduces a module option 'attach_zbc' to
>> sd which will make the sd driver accept ZBC
>> devices as normal disk drives.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>
> Looks reasonable to me.
>
> I'd also really like a sysfs file that tells us if we're dealing
> with a host aware device, as those report as TYPE_SBC.
>
Yes, eventually. But can't we defer that to a next patchset?
I'd really like to have this one in, as it makes dealing with ZAC=20
devices _so much_ easier ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
