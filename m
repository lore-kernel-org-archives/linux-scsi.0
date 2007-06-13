From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 2a/3] Expose Power Management Policy option to users
Date: Wed, 13 Jun 2007 16:48:03 -0400
Message-ID: <46705803.4000901@garzik.org>
References: <20070611184146.448266229@intel.com>	 <20070611114820.5290a903.kristen.c.accardi@intel.com>	 <466DA9DD.8080004@garzik.org>	 <20070612104631.44dab4a3.kristen.c.accardi@intel.com> <1181748408.3421.7.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1181748408.3421.7.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> To take the model I understand: SAS; the links are managed at the phy
> level, so the power policy should be set there and thus should probably
> be a property of the phy object, which doesn't even exist in the SCSI
> model, it only exists in the transport class.  It strikes me that even
> for ATA, the same thing is probably true.
> 
> Now, I can see that the power management models of all the transports
> might share some similarities (particularly at this three stage granular
> level); if so, it might make sense to export helpers from the mid-layer
> for the transport classes to use for this.


Agreed, in principle.

	Jeff


