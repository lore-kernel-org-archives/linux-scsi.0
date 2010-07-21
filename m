From: Andy Walls <awalls@md.metrocast.net>
Subject: NCR53C80 datasheet is publicly available
Date: Wed, 21 Jul 2010 17:08:50 -0400
Message-ID: <1279746530.20291.29.camel@morgan.silverblock.net>
References: <201007202228.o6KMSnYq021739@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201007202228.o6KMSnYq021739@imap1.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux@rainbow-software.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

To address James' concern for knowing how to program the NCR 53C80:

Halfway down this page, the first datasheet PDF, is a scan of the
NCR5380 family data sheet with register definitions, etc:

http://www.datasheetarchive.com/53C80-40-datasheet.html


The only cards I've ever seen with this chip were ISA bus cards wired to
respond to I/O space accesses.  These chips can be wired for MMIO as
it's just really a difference in the address decode logic.  (In fact
Appendix B of the datasheet shows the chip wired up to a 65C02 - an
ancient processor design that has no notion of I/O address space so its
I/O must be memory mapped.)

I can't seem to find a datasheet for the NCR53C400 or NCR53C400A.  The
NCR53C80 datasheet introduction implies the 5380 is used as a core in
the 53C400 though.  Since LSI Logic owns all of Symbios Logic's IP (NCR
sold off Symbios long ago), you may just need to ask LSI Logic if they
have a 53c400 datasheet available.

Regards,
Andy
