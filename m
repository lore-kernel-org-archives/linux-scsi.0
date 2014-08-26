From: Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>
Subject: Re: RES: RES: AS2105-based enclosure size issues with >2TB HDDs
Date: Tue, 26 Aug 2014 14:24:03 +0200
Message-ID: <1409055843.27494.21.camel@linux-fkkt.site>
References: <175058921e084d26ba362fa6ecd7351c@serv030.corp.eldorado.org.br>
	 <Pine.LNX.4.44L0.1408251613270.1385-100000@iolanthe.rowland.org>
	 <063D6719AE5E284EB5DD2968C1650D6D1748130C@AcuExch.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1748130C-VkEWCZq2GCInGFn1LkZF6NBPR1lH4CV8@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Laight <David.Laight-ZS65k/vG3HxXrIkS9f7CXA@public.gmane.org>
Cc: 'Alan Stern' <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Alfredo Dal Ava Junior <alfredo.junior-peCLlicIkyA3OWu3QmcX+g@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2014-08-26 at 09:58 +0000, David Laight wrote:
> > Part of the problem is that usb-storage has no way to know that
> > anything strange is going on.  It's normal for READ CAPACITY(16) to
> > fail (this depend on the SCSI level), and it's normal for the READ
> > CAPACITY(10) to report a value less than 2 TB.
> 
> Could the code try READ CAPACITY(16) first?

Yes. It does already. That fails as the device doesn't support
this version. In a way we are discussing error handling here.

	Regards
		Oliver


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
