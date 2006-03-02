From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: ATA Pass-Through support
Date: Thu, 02 Mar 2006 13:17:07 -0500
Message-ID: <440736A3.8090207@pobox.com>
References: <DF9C50EF9E8CDA45A06FE8735C68F85E5692E5@earthex2.power.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <DF9C50EF9E8CDA45A06FE8735C68F85E5692E5@earthex2.power.com>
Sender: linux-ide-owner@vger.kernel.org
To: Quat Le <Quat.Le@dothill.com>
Cc: "Moore, Eric" <Eric.Moore@lsil.com>, dougg@torque.net, linux-scsi@vger.kernel.org, Brian King <brking@us.ibm.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Quat Le wrote:
> Does anyone know of any SAS HBA vendor whose driver either uses libata
> or supports SATA Pass-Through SCSI commands in their own layer? 

Brian King, maintainer of the ipr driver, has posted patches which 
integrate libata SATA support into his driver.  Merging those is on my 
todo list, though I'm currently waiting on Tejun Heo's error handling 
work before tackling that (and NCQ and hotplug...).

	Jeff


