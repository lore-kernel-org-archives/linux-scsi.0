From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: srp_transport: Fix atttribute registration race
Date: Tue, 15 Nov 2011 08:04:51 +0100
Message-ID: <CAO+b5-q9CozVcw0GsxWQk8ORVDOFNgUETMrmWgOxB3X_9smGKw@mail.gmail.com>
References: <201110211857.23622.bvanassche@acm.org>
	<1320053608.8283.29.camel@dabdike>
	<CAO+b5-oxshsL7Dm7vhv4zC8m0P4dG3iNzxU9sdbi5cBkAnTpMQ@mail.gmail.com>
	<045e01cca1bb$3dee1070$b9ca3150$@systemfabricworks.com>
	<20111113215523.GA6117@ornl.gov>
	<CAJZOPZ+N2OLLHdKAFk=xkXGzFEdisaGsDBf6ra56pcT6zO_8qQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZ+N2OLLHdKAFk=xkXGzFEdisaGsDBf6ra56pcT6zO_8qQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Dave Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Bill Boas <bboas-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 14, 2011 at 10:43 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Sun, Nov 13, 2011 at 11:55 PM, Dave Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> > SRP uses RDMA, so you cannot use UC mode.
>
> per the IB spec, RDMA write is supported for UC

Agreed. But an SRP target does not only issue RDMA write requests, it
also issues RDMA read requests. If I interpret the IB spec correctly,
RDMA reads are not supported for UC.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
