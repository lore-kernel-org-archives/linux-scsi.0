From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [Scst-devel] [PATCH 0/7] SCST: A Generic SCSI Target Subsystem
Date: Tue, 21 Dec 2010 11:13:41 +0100
Message-ID: <AANLkTinxMKEWrspxJOV25udSrurbyAwaLbXXosdaf0E6@mail.gmail.com>
References: <201012201847.29357.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201012201847.29357.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: James.Bottomley-l3A5Bk7waGM@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 20, 2010 at 6:47 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> w=
rote:
> [ ... ]
> The most important changes since the previous time SCST was posted as=
 a
> patch set (http://lkml.org/lkml/2010/10/1/140) are:
> - Rewrote the SCST sysfs interface such that it uses the bus/driver/d=
evice
> =A0infrastructure instead of creating kernel objects in /sys/kernel/s=
cst_tgt.
> - Completed porting of the ibmvstgt driver.
> [ ... ]

Note: testing the ibmvstgt driver wouldn't have been possible without
the test setup made available by IBM. We are grateful for the
resources provided by IBM and to anyone who was involved in making
that test setup available. Also, Fujita's clean and well-structured
libsrp/ibmvstgt code was an excellent basis to start from in that
porting effort.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
