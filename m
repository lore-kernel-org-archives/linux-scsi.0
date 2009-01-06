From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [PATCH] sym53c8xx_2: lun to_clear flag not re-initialized (2.6.27.5)
Date: Tue, 06 Jan 2009 17:00:45 -0500
Message-ID: <4963D48D.6040805@cybernetics.com>
References: <49593940.9060102@cybernetics.com>	 <1230631843-16470-1-git-send-email-Aaro.Koskinen@nokia.com> <1230664572.18627.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:3367 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbZAFWAr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2009 17:00:47 -0500
In-Reply-To: <1230664572.18627.2.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Aaro Koskinen <Aaro.Koskinen@nokia.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

This patch works as advertised and fixes a real bug.

Tested-by: Tony Battersby <tonyb@cybernetics.com>

