From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: SRP over high-latency IB link
Date: Sun, 13 Nov 2011 13:12:21 +0100
Message-ID: <CAO+b5-oo2oUz9GOneM+eoawjgCsdMGSFghrKRkcmVbhmcnm3-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bboas-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Cc: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Nov 13, 2011 at 5:18 AM, Bill Boas <bboas-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> At SC we are running a video streaming demo across a 7000 mile fiber
> distance using IB extension boxes from Bay Microsystems at 40 Gbps. The
> video streaming app uses SRP to transmit the streams across this long
> distance link. Performance is not all what we would have hoped. We think
> that because SRP uses RC mode between initiator and target that it is the RC
> behavior over this distance that is impacting performance. Are any of you
> aware of an SRP implementation that uses UC mode.

What numbers are reported by ib_write_bw and ib_write_lat for that IB
link ? Do these numbers match the bandwidth and latency requirements
of the video playback application ? Which operating system was the
initiator system running ? How was read-ahead configured ? I'm not
sure it would be a good idea to try to run SRP over UC.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
