From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH v5 0/6] firmware_loader: cleanups for v4.18
Date: Fri, 4 May 2018 19:58:35 +0000
Message-ID: <20180504195835.GU27853@wotan.suse.de>
References: <20180504174356.13227-1-mcgrof@kernel.org>
 <m3lgczcjt7.fsf@pm.waw.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <m3lgczcjt7.fsf@pm.waw.pl>
Sender: linux-kernel-owner@vger.kernel.org
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, gregkh@linuxfoundation.org, akpm@linux-foundation.org, keescook@chromium.org, josh@joshtriplett.org, teg@jklm.no, wagi@monom.org, hdegoede@redhat.com, andresx7@gmail.com, zohar@linux.vnet.ibm.com, kubakici@wp.pl, shuah@kernel.org, mfuzzey@parkeon.com, dhowells@redhat.com, pali.rohar@gmail.com, tiwai@suse.de, kvalo@codeaurora.org, arend.vanspriel@broadcom.com, zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org, broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org, torvalds@linux-foundation.org, Abhay_Salunke@dell.com, bjorn.andersson@linaro.org, jewalt@lgsinnovations.com, oneukum@suse.com, cantabile.desu@gmail.com, ast@fb.com, hare@suse.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, davem@davemloft.net, maco@a
List-Id: linux-scsi@vger.kernel.org

On Fri, May 04, 2018 at 09:17:08PM +0200, Krzysztof Halasa wrote:
> "Luis R. Rodriguez" <mcgrof@kernel.org> writes:
> 
> >   * CONFIG_WANXL --> CONFIG_WANXL_BUILD_FIRMWARE
> >   * CONFIG_SCSI_AIC79XX --> CONFIG_AIC79XX_BUILD_FIRMWARE
> >
> > To this day both of these drivers are building driver *firmwares* when
> > the option CONFIG_PREVENT_FIRMWARE_BUILD is disabled, and they don't
> > even make use of the firmware API at all.
> 
> Don't know for sure about Adaptec, but wanXL firmware fits every
> definition of "stable". BTW it's a 1997 or so early PCI card, built
> around the PLX PCI9060 bus mastering PCI bridge and Motorola 68360
> (the original QUICC) processor. Maximum bit rate of 2 Mb/s on each sync
> serial port.

So we can nuke CONFIG_WANXL_BUILD_FIRMWARE now?

> It's more about delivering the .S source for the firmware, I guess.
> Nobody is expected to build it. The fw is about 2.5 KB and is directly
> linked with the driver.

:P Future work I guess would be to just use the firmware API and stuff
it into linux-firmware?

  Luis
