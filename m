From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] 1.1.4-2313 aacraid driver for LiNUX 2.4.25-pre4
Date: Wed, 7 Jan 2004 21:00:20 +0000
Sender: linux-aacraid-devel-admin-8PEkshWhKlo@public.gmane.org
Message-ID: <20040107210020.A1166@infradead.org>
References: <3FFC4C09.3020103@wanadoo.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-aacraid-devel-admin-8PEkshWhKlo@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3FFC4C09.3020103-39ZsbGIQGT7e5aOfsHch1g@public.gmane.org>; from xose-39ZsbGIQGT7e5aOfsHch1g@public.gmane.org on Wed, Jan 07, 2004 at 07:12:25PM +0100
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

On Wed, Jan 07, 2004 at 07:12:25PM +0100, Xose Vazquez Perez wrote:
> hi,
> 
> here goes latest aacraid driver, it was sent for 2.4 kernel
> inclusion. CHANGELOG has an extensive list of changes.

That's a huge mess adding lots of broken crap and hooks for binary only modules
through ioctls (urgg..).

If you want to help getting this driver merged please split out reviewable
pieces and send them to linux-scsi.

_______________________________________________
Linux-aacraid-devel mailing list
Linux-aacraid-devel-8PEkshWhKlo@public.gmane.org
http://lists.us.dell.com/mailman/listinfo/linux-aacraid-devel
Please read the FAQ at http://lists.us.dell.com/faq or search the list archives at http://lists.us.dell.com/htdig/
