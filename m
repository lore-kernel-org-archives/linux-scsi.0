From: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH v5 0/6] firmware_loader: cleanups for v4.18
Date: Fri, 04 May 2018 21:17:08 +0200
Message-ID: <m3lgczcjt7.fsf@pm.waw.pl>
References: <20180504174356.13227-1-mcgrof@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180504174356.13227-1-mcgrof@kernel.org> (Luis R. Rodriguez's
        message of "Fri, 4 May 2018 10:43:49 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: gregkh@linuxfoundation.org, akpm@linux-foundation.org, keescook@chromium.org, josh@joshtriplett.org, teg@jklm.no, wagi@monom.org, hdegoede@redhat.com, andresx7@gmail.com, zohar@linux.vnet.ibm.com, kubakici@wp.pl, shuah@kernel.org, mfuzzey@parkeon.com, dhowells@redhat.com, pali.rohar@gmail.com, tiwai@suse.de, kvalo@codeaurora.org, arend.vanspriel@broadcom.com, zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org, broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org, torvalds@linux-foundation.org, Abhay_Salunke@dell.com, bjorn.andersson@linaro.org, jewalt@lgsinnovations.com, oneukum@suse.com, cantabile.desu@gmail.com, ast@fb.com, hare@suse.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, davem@davemloft.net, maco@android.com, arve@android.com, tkjos@andro
List-Id: linux-scsi@vger.kernel.org

"Luis R. Rodriguez" <mcgrof@kernel.org> writes:

>   * CONFIG_WANXL --> CONFIG_WANXL_BUILD_FIRMWARE
>   * CONFIG_SCSI_AIC79XX --> CONFIG_AIC79XX_BUILD_FIRMWARE
>
> To this day both of these drivers are building driver *firmwares* when
> the option CONFIG_PREVENT_FIRMWARE_BUILD is disabled, and they don't
> even make use of the firmware API at all.

Don't know for sure about Adaptec, but wanXL firmware fits every
definition of "stable". BTW it's a 1997 or so early PCI card, built
around the PLX PCI9060 bus mastering PCI bridge and Motorola 68360
(the original QUICC) processor. Maximum bit rate of 2 Mb/s on each sync
serial port.

It's more about delivering the .S source for the firmware, I guess.
Nobody is expected to build it. The fw is about 2.5 KB and is directly
linked with the driver.
-- 
Krzysztof Halasa
