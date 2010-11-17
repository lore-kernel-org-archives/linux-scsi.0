From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] libata: remove scsi host lock and serial number usage
Date: Wed, 17 Nov 2010 10:15:54 -0800
Message-ID: <AANLkTimwwCDfXSk5aEfHv3qzcvTzOQUB5fOCU4c5JJ8V@mail.gmail.com>
References: <20101117172111.GA26812@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20101117172111.GA26812@havoc.gtf.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, James.Bottomley@suse.de
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 17, 2010 at 9:21 AM, Jeff Garzik <jeff@garzik.org> wrote:
>
> Much better... =A0Just updated #upstream-fixes with the below patch.

Yes. This looks like a real improvement and actually gets rid of that
silly lock entirely. Good.

                       Linus
