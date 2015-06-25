From: "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>
Subject: Re: [PATCH 1/1] scsi/snic: fixing the error print
Date: Thu, 25 Jun 2015 10:23:23 +0000
Message-ID: <D1B1D42E.28756%nmusini@cisco.com>
References: <1435225936-10250-1-git-send-email-maninder1.s@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-2.cisco.com ([173.37.142.89]:7742 "EHLO
	alln-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbbFYKXZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jun 2015 06:23:25 -0400
In-Reply-To: <1435225936-10250-1-git-send-email-maninder1.s@samsung.com>
Content-Language: en-US
Content-ID: <7E2069CFBF3F474BBD3D0992B4F577EB@emea.cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maninder Singh <maninder1.s@samsung.com>, "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>, "JBottomley@odin.com" <JBottomley@odin.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "pankaj.m@samsung.com" <pankaj.m@samsung.com>


On 25/06/15 3:22 pm, "Maninder Singh" <maninder1.s@samsung.com> wrote:

>Currently SNIC_HOST_ERR is called in both cases
>whether snic_disc_start returns zero or non-zero.
>
>From the code it looks like it has to print only if
>snic_disc_start return non-zero value, So calling
>SNIC_HOST_ERR only for non-zero return from snic_disc_start.
>
>Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
>Reviewed-by: Rohit Thapliyal <r.thapliyal@samsung.com>

Acked-by: Narsimhulu Musini <nmusini@cisco.com>

