From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: How to map between /dev/sdX and dev/sgX devices?
Date: Thu, 19 Aug 2004 17:04:27 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFD977F11A.0A4E1B0D-ON88256EF6.0000404E-88256EF6.0000586E@us.ibm.com>
References: <4125249A.30808@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:45765 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S267529AbUHTAF3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 20:05:29 -0400
In-Reply-To: <4125249A.30808@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

>> don't..... use SG_IO on the device directly
>
>and if that breaks your app then try the equivalent
>sg device to check that you haven't tripped over another
>QOI issue.

What is QOI?
