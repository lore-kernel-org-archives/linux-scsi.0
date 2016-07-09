From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC] libata-scsi: introducing SANITIZE translation
Date: Fri, 08 Jul 2016 17:49:58 -0700
Message-ID: <1468025398.2390.24.camel@HansenPartnership.com>
References: <577e843e.0a86620a.59167.ffffb899@mx.google.com>
	 <1467910054.2322.7.camel@HansenPartnership.com>
	 <CAGnHSE=8HEZ8AnDGjdOAhaA8f117GdbZZNhbQQOCYYM1b-8PvQ@mail.gmail.com>
	 <1467998971.2343.10.camel@HansenPartnership.com>
	 <CAGnHSEkLer=GRZxoc=AmS7J_oe945hSdUV2TisSuvfXdCPQ2Ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAGnHSEkLer=GRZxoc=AmS7J_oe945hSdUV2TisSuvfXdCPQ2Ow@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, martin.petersen@oracle.com, dgilbert@interlog.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2016-07-08 at 19:38 +0000, Tom Yan wrote:
> On 8 July 2016 at 17:29, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > Or we could simply patch sg_sanitze to issue the ATA_16 pass 
> > through when it sees a sata device ...
> > 
> 
> Ugh that sounds ugly to me. Anyway that's off-topic.

Not really.  The point is that you've proposed something as an addition
to the kernel that can also be done in userspace.  Checking if it can
work easily there is like a barrier to entry.  If it works, then fine,
we're done.  If it throws up problems then we reconsider the kernel
route.

James

