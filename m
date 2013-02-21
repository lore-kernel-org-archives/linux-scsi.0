From: Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [usb-storage] Re: Issue with mini-SaS to eSATA to USB 3.0 setup
Date: Thu, 21 Feb 2013 22:53:34 +0100
Message-ID: <20130221215334.GA3208@suse.cz>
References: <CAAfSSYhT+r07yQfok_BvKj_bTnCUv7nMX8Wafd-xjB1ejEZusQ@mail.gmail.com>
 <CAAfSSYj4ycBUVW3rVy1jrbJEY2hW_Ui88MyWdA5yGose80Vggw@mail.gmail.com>
 <20130221192646.GE27219@xanatos>
 <5126882A.1060603@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5126882A.1060603-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>
Cc: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Fabio David <fabiodavid-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Feb 21, 2013 at 03:48:42PM -0500, Douglas Gilbert wrote:
> On 13-02-21 02:26 PM, Sarah Sharp wrote:
> >Cc-ing the SCSI and USB storage list.
> >
> >Folks, does the attached picture look like a sane setup?  I've never
> >used mini-SaS to eSATA adapter before, let alone with four eSATA to USB
> >3.0 adapters.
> 
> Well SAS to eSATA is okay (works for me: LSI SAS9212-4i4e HBA
> via a SATA to eSATA cable to a SATA disk caddy with an eSATA
> port).

This seems to be all just SATA signalling, no SAS involved at all, just
the physical shape of the connector is miniSAS.

-- 
Vojtech Pavlik
Director SuSE Labs
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
