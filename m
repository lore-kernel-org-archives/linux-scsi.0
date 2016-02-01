From: Alex Gorbachev <ag@iss-integration.com>
Subject: Re: [LSF/MM TOPIC] LIO/SCST Merger
Date: Sun, 31 Jan 2016 21:44:16 -0500
Message-ID: <CADb9450kp3wYHs0ODXD3SP5=YHg1L1zN79UKDmJnnph9F1WTQw@mail.gmail.com>
References: <56A9043B.7030207@sandisk.com>
	<1453963019.6746.244.camel@haakon3.risingtidesystems.com>
	<56AA3518.8060507@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <56AA3518.8060507@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

$0.02 from the heavy user of both frameworks in mission critical
clinical environment, we tremendously appreciate the contribution of
all developers, maintainers and organizers, the innovative and
versatile approach of LIO (especially the Ceph back end for us) and
the stability and automation of SCST.  I hope the great work you guys
are doing is able to complement each other and result in powerful
solutions that will allow us, Mission Critical users, designers and
integrators, to offer a truly competitive options to large box SANs.

What you are doing makes a difference every day.

--
Alex Gorbachev
Storcium


On Thu, Jan 28, 2016 at 10:34 AM, Bart Van Assche
<bart.vanassche@sandisk.com> wrote:
> On 01/27/16 22:37, Nicholas A. Bellinger wrote:
>>
>> [ ... ]
>
>
> Hi Nic,
>
> Since in the most recent years all my communication to you was neutral and
> professional in tone it is not clear to me why you wrote such a misleading
> and unfair e-mail. Anyway, I would like to point out that the following
> information is missing from your e-mail:
> - That last year the storage HBA vendors and Linux distributor
>   representatives who attended my session about this topic where
>   unanimously enthusiastic about my proposal. You were the only
>   attendee who was not (yet?) enthusiast.
> - That I am working on sending the ib_srpt patches upstream you
>   referred to in your e-mail and that a first version of that patch
>   series has already been posted on the linux-rdma mailing list.
> - Although five years ago some SCST users switched to LIO, recently
>   several LIO users switched back to SCST because the latter is still
>   more stable and easier to configure than LIO. In other words, it is
>   in your own interest to help the LIO patches upstream that I posted
>   recently.
> - One of the reasons that the LIO core patches I'm working on are not
>   yet upstream is because of how long it takes before you as a
>   maintainer provide feedback. The first version of my patch to make
>   ABORT and LUN RESET handling synchronous was posted on October 12,
>   2015. It took until November 15, 2015 before I received the first
>   feedback from you for that patch.
>
> Bart.
>
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
