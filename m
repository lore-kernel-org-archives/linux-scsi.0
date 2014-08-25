From: Alfredo Dal Ava Junior <alfredo.junior-peCLlicIkyA3OWu3QmcX+g@public.gmane.org>
Subject: RES: AS2105-based enclosure size issues with >2TB HDDs
Date: Mon, 25 Aug 2014 18:48:26 +0000
Message-ID: <40601ab081d3451baf6267807659c80e@serv030.corp.eldorado.org.br>
References: <1408972618.10300.35.camel@linux-fkkt.site>
 <Pine.LNX.4.44L0.1408251021560.1385-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1408251021560.1385-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Content-Language: pt-BR
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>
Cc: "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 25 Aug 2014, Alan Stern wrote:
> 
> Don't forget that lots of disks go crazy if you try to read from a nonexistent
> block, that is, one beyond the end of the disk.
> IMO, this bug cannot be worked around in any reasonable manner.  The
> device simply cannot handle disks larger than 2 TB.


This device works well on Windows 7 if HDD is already partitioned. Sounds like Win7 gnores the READ_CAPACITY value on a partitioned HDD. It shows 4TB on disk manager, but will fall back to 1.8TB if I remove the partition.
Could we do the same? Would be possible to signalize to upper layers that capacity is not accurate (or return zero) on this device, and tell GPT handlers to bypass it's partition_size vs disk size consistency check?

Thanks,
Alfredo
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
