From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [TRIVIAL] Re: aic7xxx gcc3 warning fix
Date: Sat, 27 Jul 2002 14:14:31 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020727042038.BBC52412A@lists.samba.org>
References: <20020726101754.A6596@infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: Your message of "Fri, 26 Jul 2002 10:17:54 +0100."
             <20020726101754.A6596@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: dledford@redhat.com, linux-scsi@vger.kernel.org

In message <20020726101754.A6596@infradead.org> you write:
> Can't we just remove this stupid option parsing entirely in 2.5 and make it
> take sane module options?  

Yes.  I will be updating my PARAM() patches RSN.

Of course, you have to make sure the boot command length limit is
sane, too.

Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
