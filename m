From: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [2/3] 2.6.22-rc3: known regressions v2
Date: Fri, 1 Jun 2007 12:54:58 -0700
Message-ID: <86802c440706011254k4aa5bc05rf63e573b1e0ed9bd@mail.gmail.com>
References: <20070601175344.GA13721@in.ibm.com>
	 <AE4F746F2AECFC4DA4AADD66A1DFEF01A55540@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01A55540@otce2k301.adaptec.com>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: vgoyal@in.ibm.com, Andrew Morton <akpm@linux-foundation.org>, Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-pcmcia@lists.infradead.org, Robert de Rooy <robert.de.rooy@gmail.com>, Alan Cox <alan@redhat.com>, Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org, Jeff Garzik <jeff@garzik.org>, Gregor Jasny <gjasny@googlemail.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, sparclinux@vger.kernel.org, David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>
List-Id: linux-scsi@vger.kernel.org

On 6/1/07, Salyzyn, Mark <mark_salyzyn@adaptec.com> wrote:
> Agree, but overstated somewhat.
>
> The card in question that the regression is reported against is not a
> released card and as such could have a flawed environment, Hardware,
> Firmware or other Incompatibility. The fix for the root cause will
> likely not touch the driver or the kernel

So aacraid.reset_devices=1 works with Vivek's test system?

YH
