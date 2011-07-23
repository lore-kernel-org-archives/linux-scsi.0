From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 7/8] lpfc 8.3.25: Add FCF priority failover functionality
Date: Fri, 22 Jul 2011 20:45:55 -0500
Message-ID: <4E2A27D3.2020207@cs.wisc.edu>
References: <1311374291.10545.34.camel@wookie>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39084 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab1GWBqF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jul 2011 21:46:05 -0400
In-Reply-To: <1311374291.10545.34.camel@wookie>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: linux-scsi@vger.kernel.org

On 07/22/2011 05:37 PM, James Smart wrote
> priority. This patch also introduces a new sysfs parameter
> (fcf_failover_policy) to allow the user to choose which FCF failover policy
> to use.

I thought something like that was going to go in the sysfs tree Rob was
working on?
