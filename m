From: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Subject: Re: [PATCH 4/4] dpt_i2o: sysfs code
Date: Fri, 2 May 2008 09:28:36 -0400
Message-ID: <F97921C9-9AA2-4485-948C-44F80F9F17BC@adaptec.com>
References: <20080501230815.GA19856@xs4all.net>
Mime-Version: 1.0 (Apple Message framework v919.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:57440 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760382AbYEBN2h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 09:28:37 -0400
In-Reply-To: <20080501230815.GA19856@xs4all.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

ACK

On May 1, 2008, at 7:08 PM, Miquel van Smoorenburg wrote:

> [PATCH 4/4] dpt_i2o: sysfs code
>
> Create a /sys/class/dpt_i2o directory and populate it with
> dptiN directories. Each dptiN directory contains a "dev" file
> that makes udev create /dev/dptiN
>
> Signed-off-by: Miquel van Smoorenburg <miquels@cistron.nl>
>
