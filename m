From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: Re: [PATCH v2 00/26] ReST conversion of text files without .txt
 extension
Date: Fri, 26 Jul 2019 10:05:33 -0300
Message-ID: <20190726100521.5d379300@coco.lan>
References: <cover.1564145354.git.mchehab+samsung@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1564145354.git.mchehab+samsung@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org, linux-pci@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, linux-i2c@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-spi@vger.kernel.org, linux-iio@vger.kernel.org, linux-rtc@vger.kernel.org, netdev@vger.kernel.org, linux-parisc@vger.kernel.org, openrisc@lists.librecores.org, devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, devel@lists.orangefs.org, dmaengine@vger.kernel.org, alsa-devel@alsa-project.org, linux-mips@vger.kernel.org, linux-wireless@vger.kernel.org, rcu@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Em Fri, 26 Jul 2019 09:51:10 -0300
Mauro Carvalho Chehab <mchehab+samsung@kernel.org> escreveu:

> This series converts the text files under Documentation with doesn't end
> neither .txt or .rst and are not part of ABI or features.
> 
> This series is at:
> 	https://git.linuxtv.org/mchehab/experimental.git/log/?h=rst_for_5_4_v3
> 
> And it is based on yesterday's upstream tree.
> 
> After this series, we have ~320 files left to be converted to ReST.
> 
> v2:
>   - Added 3 files submitted for v5.3 that weren't merged yet;
>   - markdown patch broken into two, per Rob's request;
>   - rebased on the top of upstream master branch
> 
> Mauro Carvalho Chehab (26):

>   docs: ABI: remove extension from sysfs-class-mic.txt

    ^ In time: this one was already merged.

Thanks,
Mauro
