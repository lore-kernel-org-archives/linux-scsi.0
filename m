From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH 8/9] ib_srpt: Convert srp_max_rsp_size into per port
 configfs attribute
Date: Mon, 24 Oct 2011 13:22:34 -0700
Message-ID: <1319487754.17450.69.camel@haakon2.linux-iscsi.org>
References: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org>
	 <1319434422-15354-9-git-send-email-nab@linux-iscsi.org>
	 <CAO+b5-p24uYKbwqCRWVik63gL-ZABgcJrqAi7ULJZEP+CK1WEg@mail.gmail.com>
	 <1319485752.17450.57.camel@haakon2.linux-iscsi.org>
	 <CAO+b5-rzo478a07CuaYS2itAdV9dK65+GHj2Si4PZFM6qkmL3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-rzo478a07CuaYS2itAdV9dK65+GHj2Si4PZFM6qkmL3A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-10-24 at 22:16 +0200, Bart Van Assche wrote:
> On Mon, Oct 24, 2011 at 9:49 PM, Nicholas A. Bellinger
> <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> > On Mon, 2011-10-24 at 21:44 +0200, Bart Van Assche wrote:
> >> Also, isn't kstrto*() preferred over strict_strto*() ?
> >
> > Not AFAIK.
> 
> This is what I found in the description of commit 33ee3b2:
> 
>     kstrto*: converting strings to integers done (hopefully) right
> 
>     1. simple_strto*() do not contain overflow checks and crufty,
>        libc way to indicate failure.
>     2. strict_strto*() also do not have overflow checks but the name and
>        comments pretend they do.
>     3. Both families have only "long long" and "long" variants,
>        but users want strtou8()
>     4. Both "simple" and "strict" prefixes are wrong:
>        Simple doesn't exactly say what's so simple, strict should not exist
>        because conversion should be strict by default.
> 
>     The solution is to use "k" prefix and add convertors for more types.
>     Enter
>         kstrtoull()
>         ...

Fair enough.  I'll convert this separately after the merge considering
it's a very minor improvement, and not a bugfix.

--nab



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
