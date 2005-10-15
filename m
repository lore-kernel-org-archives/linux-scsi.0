From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 0/3] libata: scsi error handling, encore
Date: Fri, 14 Oct 2005 22:34:11 -0400
Message-ID: <43506AA3.3030502@pobox.com>
References: <43490BC8.9060504@torque.net> <434919E4.1080601@pobox.com> <435069E3.90306@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:27035 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751041AbVJOCeU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Oct 2005 22:34:20 -0400
In-Reply-To: <435069E3.90306@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, htejun@gmail.com, russb@emc.com

Douglas Gilbert wrote:
> Six days have passed and "git pull ..../libata-dev" still
> does not reflect these changes. Am I doing something
> wrong? Should I wait before submitting more changes?

Your changes are committed to the 'upstream' branch.  Maybe you need to do
	git pull $url upstream
?

	Jeff


