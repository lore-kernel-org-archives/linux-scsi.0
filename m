From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re:
 [REGRESSION][Stable][v3.12.y][v4.4.y][v4.9.y][v4.10.y][v4.11-rc1] scsi:
 storvsc: properly set residual data length on errors
Date: Thu, 30 Mar 2017 10:03:06 +0200
Message-ID: <20170330080306.GA15809@kroah.com>
References: <5df6cd65-92d5-e4c5-56e3-771643f86861@canonical.com>
 <BLUPR0301MB2098AF08A8AFFC22F2B5D67ACC330@BLUPR0301MB2098.namprd03.prod.outlook.com>
 <f8e619e0-d8b6-bd2f-1a92-c52fbc4b5550@canonical.com>
 <BLUPR0301MB2098105B51A887EEBA6EFD90CC320@BLUPR0301MB2098.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <BLUPR0301MB2098105B51A887EEBA6EFD90CC320@BLUPR0301MB2098.namprd03.prod.outlook.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Stephen Hemminger <sthemmin@microsoft.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, LKML <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, Haiyang Zhang <haiyangz@microsoft.com>, Joseph Salisbury <joseph.salisbury@canonical.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 28, 2017 at 04:14:09PM +0000, Stephen Hemminger wrote:
> I decided not to send it to stable since problem was only observed on
> 4.11 but it is probably endemic to all GEN2 VM's

So, what does this mean?  What should stable@ do?  Nothing?  Ok, now
dropped this from my patch queue :)

thanks,

greg k-h
