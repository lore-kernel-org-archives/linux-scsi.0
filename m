From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [RFC] libata-scsi: introducing SANITIZE translation
Date: Fri, 8 Jul 2016 19:38:03 +0000
Message-ID: <CAGnHSEkLer=GRZxoc=AmS7J_oe945hSdUV2TisSuvfXdCPQ2Ow@mail.gmail.com>
References: <577e843e.0a86620a.59167.ffffb899@mx.google.com>
 <1467910054.2322.7.camel@HansenPartnership.com> <CAGnHSE=8HEZ8AnDGjdOAhaA8f117GdbZZNhbQQOCYYM1b-8PvQ@mail.gmail.com>
 <1467998971.2343.10.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1467998971.2343.10.camel@HansenPartnership.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Tejun Heo <tj@kernel.org>, martin.petersen@oracle.com, dgilbert@interlog.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 8 July 2016 at 17:29, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> OK, since you ignore the argument about maintenance: safety for us
> means that it doesn't bitrot as an almost never used addition.  The
> reason our SATL should only support the commands Linux uses is
> precisely because if it's used often we get immediate notice of when we
> break it.  This maintenance burden means that adding stuff isn't free
> so we should have some utility bar before we do it.  Just "because we
> can" doesn't seem to rise to that.
>

Well yeah it might rot just like other parts of the current SATL, but
at least its rot would be self-contained. I don't really find it "an
almost never used addition" btw. It's just a handy feature set that no
one has implemented any interface for users to make use of it.

>
> Or we could simply patch sg_sanitze to issue the ATA_16 pass through
> when it sees a sata device ...
>

Ugh that sounds ugly to me. Anyway that's off-topic.

>
> To be honest, I bet real security people won't even trust the drive
> firmware.  Their answer will still be dd random patterns to prevent
> easy retrieval then crush the drive to prevent forensic retrieval.
>

You know what, I don't think the feature set is totally about
"security" anyway. It's just a handy way quickly (that's partly why I
didn't bother to implement translation for OVERWRITE) erase all the
data. Also, whether one considers it secure enough or not would be
purely his opinion under the usage context of his own, as always.
