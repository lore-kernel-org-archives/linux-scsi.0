From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Subject: Re: [PATCH v2 03/17] compat_ioctl: use correct compat_ptr()
 translation in drivers
Date: Thu, 13 Sep 2018 10:48:15 +1000
Message-ID: <11132252-c6ba-8b53-9314-f91e77574eba@au1.ibm.com>
References: <20180912150142.157913-1-arnd@arndb.de>
 <20180912150142.157913-3-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180912150142.157913-3-arnd@arndb.de>
Content-Language: en-AU
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Frank Haverkamp <haver@linux.vnet.ibm.com>, "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Felipe Balbi <balbi@kernel.org>, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 13/09/18 01:01, Arnd Bergmann wrote:
> A handful of drivers all have a trivial wrapper around their ioctl
> handler, but don't call the compat_ptr() conversion function at the
> moment. In practice this does not matter, since none of them are used
> on the s390 architecture and for all other architectures, compat_ptr()
> does not do anything, but using the new generic_compat_ioctl_ptrarg
> helper makes it more correct in theory, and simplifies the code.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

For cxl:

Acked-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>

-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited
