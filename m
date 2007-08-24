From: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH 20/30] scsi: In the Advansys driver, do not cast allocation function return values
Date: Fri, 24 Aug 2007 11:00:43 +0200
Message-ID: <9a8748490708240200w3df4756fpd32e5b84dcb7f18a@mail.gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
	 <82de4728edd63551c2c8a2fff0350f0917ed73a5.1187912217.git.jesper.juhl@gmail.com>
	 <20070824020349.GS9163@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932369AbXHXJA5@vger.kernel.org>
In-Reply-To: <20070824020349.GS9163@parisc-linux.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, linux@connectcom.net
List-Id: linux-scsi@vger.kernel.org

On 24/08/07, Matthew Wilcox <matthew@wil.cx> wrote:
> On Fri, Aug 24, 2007 at 02:16:12AM +0200, Jesper Juhl wrote:
> > There's no reason to cast void pointers returned by the generic
> > memory allocation functions.
>
> I think I fixed all these already; please check scsi-misc.
>
I just checked out the latest scsi-misc-2.6 tree and it does indeed
look like these have already been dealt with.
Sorry about the noise.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
