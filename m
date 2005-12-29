From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Qlogic build question
Date: Thu, 29 Dec 2005 16:55:16 +0100
Message-ID: <1135871716.2935.59.camel@laptopd505.fenrus.org>
References: <7F012BDECA7C2C46BB3BB0C71B8CE019010C5A@XYUS-EX21.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:22168 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750776AbVL2PzT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Dec 2005 10:55:19 -0500
In-Reply-To: <7F012BDECA7C2C46BB3BB0C71B8CE019010C5A@XYUS-EX21.xyus.xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Frank Borich <Frank_Borich@us.xyratex.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 2005-12-29 at 07:48 -0800, Frank Borich wrote:
> Hi,
> 
> According to documentation included with the Qlogic driver source
> you can compile the driver for a SMP system using:
> 
> make SMP=1

that sounds highly outdated and incorrect and also only applicable if
you want to build some weird variant of the driver in an out-of-tree
way ;)

> 
> Does anybody know if this will happen automtically on multiprocessor
> systems
> during installation of Red Hat AS3 distribution using CDs ?

the drivers on those CDs are correctly compiled for SMP or UP (depending
on the kernel they're built for), as is the case for the current
in-kernel qlogic driver.



