From: Xose Vazquez Perez <xose-39ZsbGIQGT7e5aOfsHch1g@public.gmane.org>
Subject: Re: [PATCH] 1.1.4-2313 aacraid driver for LiNUX 2.4.25-pre4
Date: Thu, 08 Jan 2004 16:58:50 +0100
Sender: linux-aacraid-devel-admin-8PEkshWhKlo@public.gmane.org
Message-ID: <3FFD7E3A.3010808@wanadoo.es>
References: <3FFC4C09.3020103@wanadoo.es> <20040107210020.A1166@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-aacraid-devel-admin-8PEkshWhKlo@public.gmane.org>
Errors-To: linux-aacraid-devel-admin-8PEkshWhKlo@public.gmane.org
List-Help: <mailto:linux-aacraid-devel-request-8PEkshWhKlpvbvzxeQLTJuMTnGGMi8c9@public.gmane.org>
List-Post: <mailto:linux-aacraid-devel-8PEkshWhKlo@public.gmane.org>
List-Subscribe: <http://lists.us.dell.com/mailman/listinfo/linux-aacraid-devel>,
	<mailto:linux-aacraid-devel-request-8PEkshWhKlpvbvzxeQLTJhLjRD9WNpgrmSKB9SHqsyg@public.gmane.org>
List-Unsubscribe: <http://lists.us.dell.com/mailman/listinfo/linux-aacraid-devel>,
	<mailto:linux-aacraid-devel-request-8PEkshWhKlpvbvzxeQLTJt/CJOUnrhF+9vnX9k1QryA@public.gmane.org>
List-Archive: <http://lists.us.dell.com/pipermail/linux-aacraid-devel/>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-aacraid-devel-XtjxT7Vmt5ZskZv2Y/7f+AC/G2K4zDHf@public.gmane.org, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:

> That's a huge mess adding lots of broken crap and hooks for binary only modules
> through ioctls (urgg..).

yes, but the driver was sent to Marcelo without to pass linux-scsi revision, like
others drivers. And I think that is very important a NET review before the inclusion
in kernel.org tree.

> If you want to help getting this driver merged please split out reviewable
> pieces and send them to linux-scsi.

Mark Salyzyn(adaptec) and Mark Haverkamp(osdl) already are working on it.

_______________________________________________
Linux-aacraid-devel mailing list
Linux-aacraid-devel-8PEkshWhKlo@public.gmane.org
http://lists.us.dell.com/mailman/listinfo/linux-aacraid-devel
Please read the FAQ at http://lists.us.dell.com/faq or search the list archives at http://lists.us.dell.com/htdig/
