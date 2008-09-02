From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC][PATCH] ahci: Add support for Promise PDC42819
Date: Tue, 02 Sep 2008 07:19:18 -0400
Message-ID: <48BD2136.1020101@garzik.org>
References: <65a6ef750809020403i52228319u9e3197e4062941bc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <65a6ef750809020403i52228319u9e3197e4062941bc@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Nelson <mdnelson8@gmail.com>
Cc: linux-ide@vger.kernel.org, Mikael Pettersson <mikpe@it.uu.se>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Mark Nelson wrote:
> Add an appropriate entry for the Promise PDC42819 controller. It has an
> AHCI mode and seems to work correctly with board_ahci.
> 
> This chip is found on Promise's FastTrak TX2650 (2 port) and TX4650 (4 port)
> software-based RAID cards (for which there is a binary driver, t3sas) and
> can be found on some motherboards, for example the MSI K9A2 Platinum,
> which calls the chip a Promise T3 controller.
> 
> Signed-off-by: Mark Nelson <mdnelson8@gmail.com>
> ---
> Apparently this chip also supports SAS disks, will these work with the
> ahci driver (I've only tested with normal desktop SATA disks)?

ahci is definitely SATA-only, so I wonder how they modified AHCI to 
support SAS transport...

	Jeff



