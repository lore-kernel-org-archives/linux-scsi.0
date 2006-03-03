From: Brian King <brking@us.ibm.com>
Subject: Re: ATA Pass-Through support
Date: Fri, 03 Mar 2006 10:50:13 -0600
Message-ID: <440873C5.8050403@us.ibm.com>
References: <DF9C50EF9E8CDA45A06FE8735C68F85E5692E5@earthex2.power.com> <440736A3.8090207@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <440736A3.8090207@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Quat Le <Quat.Le@dothill.com>, "Moore, Eric" <Eric.Moore@lsil.com>, dougg@torque.net, linux-scsi@vger.kernel.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, htejun@gmail.com
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Quat Le wrote:
>> Does anyone know of any SAS HBA vendor whose driver either uses libata
>> or supports SATA Pass-Through SCSI commands in their own layer? 
> 
> Brian King, maintainer of the ipr driver, has posted patches which 
> integrate libata SATA support into his driver.  Merging those is on my 
> todo list, though I'm currently waiting on Tejun Heo's error handling 
> work before tackling that (and NCQ and hotplug...).

Tejen,

Is there anything I can do to help with the error handling work Jeff
is referring to?

Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
