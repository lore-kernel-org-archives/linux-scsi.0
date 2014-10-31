From: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v2 10/12] IB/srp: Use block layer tags
Date: Fri, 31 Oct 2014 18:34:01 +0100
Message-ID: <5453C809.9060004@suse.de>
References: <5433E43D.3010107@acm.org> <5433E557.3010505@acm.org> <94D0CD8314A33A4D9D801C0FE68B4029593212E0@G4W3296.americas.hpqcorp.net> <20141023084744.GA24965@infradead.org> <94D0CD8314A33A4D9D801C0FE68B402959324A17@G4W3296.americas.hpqcorp.net> <20141024064514.GA15654@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141024064514.GA15654-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Elliott, Robert (Server Storage)" <Elliott-VXdhtT5mjnY@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Scales, Webb" <webb.scales-VXdhtT5mjnY@public.gmane.org>, "Don Brace (PMC)" <Don.Brace-PwyqCcigF0Q@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 10/24/2014 08:45 AM, Christoph Hellwig wrote:
> On Fri, Oct 24, 2014 at 04:43:15AM +0000, Elliott, Robert (Server Sto=
rage) wrote:
>> However, it was looking at scmd->tag, which is always 0xff (at=20
>> least in those early discovery commands).  scmd->request->tag=20
>> looks like it is the field that has the correct values.
>>
>> Also, I noticed that scmd->tag is just an 8 bit field, so
>> it could never represent a large number of tags.
>=20
> Yes, we need to get rid of scmd->tag.  Hannes had a patchset to get
> started on it, and I hope either he or someone else will have time to
> get back to it ASAP.
>=20
I'm planning on doing so; just waiting for the NCR5380 cleanup
to get in.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare-l3A5Bk7waGM@public.gmane.org			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
