From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] 1.1.4-2313 aacraid driver for LiNUX 2.4.25-pre4
Date: Thu, 8 Jan 2004 16:04:31 +0000
Sender: linux-aacraid-devel-admin-8PEkshWhKlo@public.gmane.org
Message-ID: <20040108160431.A11515@infradead.org>
References: <3FFC4C09.3020103@wanadoo.es> <20040107210020.A1166@infradead.org> <3FFD7E3A.3010808@wanadoo.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-aacraid-devel-admin-8PEkshWhKlo@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3FFD7E3A.3010808-39ZsbGIQGT7e5aOfsHch1g@public.gmane.org>; from xose-39ZsbGIQGT7e5aOfsHch1g@public.gmane.org on Thu, Jan 08, 2004 at 04:58:50PM +0100
Errors-To: linux-aacraid-devel-admin-8PEkshWhKlo@public.gmane.org
List-Help: <mailto:linux-aacraid-devel-request-8PEkshWhKlpvbvzxeQLTJuMTnGGMi8c9@public.gmane.org>
List-Post: <mailto:linux-aacraid-devel-8PEkshWhKlo@public.gmane.org>
List-Subscribe: <http://lists.us.dell.com/mailman/listinfo/linux-aacraid-devel>,
	<mailto:linux-aacraid-devel-request-8PEkshWhKlpvbvzxeQLTJhLjRD9WNpgrmSKB9SHqsyg@public.gmane.org>
List-Unsubscribe: <http://lists.us.dell.com/mailman/listinfo/linux-aacraid-devel>,
	<mailto:linux-aacraid-devel-request-8PEkshWhKlpvbvzxeQLTJt/CJOUnrhF+9vnX9k1QryA@public.gmane.org>
List-Archive: <http://lists.us.dell.com/pipermail/linux-aacraid-devel/>
To: Xose Vazquez Perez <xose-39ZsbGIQGT7e5aOfsHch1g@public.gmane.org>
Cc: linux-aacraid-devel-XtjxT7Vmt5ZskZv2Y/7f+AC/G2K4zDHf@public.gmane.org, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 08, 2004 at 04:58:50PM +0100, Xose Vazquez Perez wrote:
> Christoph Hellwig wrote:
> 
> > That's a huge mess adding lots of broken crap and hooks for binary only modules
> > through ioctls (urgg..).
> 
> yes, but the driver was sent to Marcelo without to pass linux-scsi revision, like
> others drivers. And I think that is very important a NET review before the inclusion
> in kernel.org tree.

Well, the review is pretty short.  The driver is an unreadable POS that
introduces bugs and backdoors for binary modules.

If marcelo is going to merge it anyway I'll urge him to back it out.

And who the heck thinks it's a good idea to submit scsi driver directly
instead of through the proper lists?

_______________________________________________
Linux-aacraid-devel mailing list
Linux-aacraid-devel-8PEkshWhKlo@public.gmane.org
http://lists.us.dell.com/mailman/listinfo/linux-aacraid-devel
Please read the FAQ at http://lists.us.dell.com/faq or search the list archives at http://lists.us.dell.com/htdig/
