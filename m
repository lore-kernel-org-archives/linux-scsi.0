From: James Smart <James.Smart@Emulex.Com>
Subject: Re: fc_remote_port_delete and returning SCSI commands from LLD
Date: Fri, 23 Oct 2009 10:50:15 -0400
Message-ID: <4AE1C2A7.3040508@emulex.com>
References: <20091020144027.GA17717@schmichrtp.de.ibm.com> <20091021152437.GA19717@schmichrtp.de.ibm.com> <4ADF37D5.5090507@emulex.com> <20091023075839.GC5930@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:46230 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbZJWOuO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Oct 2009 10:50:14 -0400
In-Reply-To: <20091023075839.GC5930@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Christof Schmitt wrote:
> It looks to me like this is required to prevent offline SCSI devices
> in this case. Should this code be in a FC transport helper function
> rather than being duplicated in each FC LLD?

That would make sense....

-- james s


