From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 1/8] qla2xxx: kill sessions/log out initiator on RSCN
 and port down events
Date: Tue, 28 Jul 2015 07:54:14 +0200
Message-ID: <55B71906.8050807@suse.de>
References: <1436904049-27707-1-git-send-email-himanshu.madhani@qlogic.com> <1436904049-27707-2-git-send-email-himanshu.madhani@qlogic.com> <55B5E725.4020502@suse.de> <CAL1RGDVUgZVsvh9ppP+c4BCbOOncCz=AUsDctYgQzHQVDKsyZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAL1RGDVUgZVsvh9ppP+c4BCbOOncCz=AUsDctYgQzHQVDKsyZw@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 07/27/2015 08:09 PM, Roland Dreier wrote:
> On Mon, Jul 27, 2015 at 1:09 AM, Hannes Reinecke <hare@suse.de> wrote=
:
>> Hmm? What happened to the original FIXME?
>> Is it not required anymore?
>=20
> Not sure I follow the question.  The original FIXME was "/* FIXME:
> Re-enable Global event handling.. */" and this patch indeed re-enable=
s
> global event handling.  I don't think it's a separate patch, it's all
> part of the same work.
>=20
> Unless I'm misunderstanding...
>=20
No, not really.
If the patch indeed enables global event handling everything's fine.
Wasn't just not quite obvious from the description nor the patch itself=
=2E

So:

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
