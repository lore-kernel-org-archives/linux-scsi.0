From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: Simulating faulty disk
Date: Thu, 20 Oct 2011 10:27:26 +0100
Message-ID: <4E9FE97E.4030209@redhat.com>
References: <4E9F9321.8090704@cs.utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755439Ab1JTJ13 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2011 05:27:29 -0400
In-Reply-To: <4E9F9321.8090704@cs.utah.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yathindra <ydev@cs.utah.edu>
Cc: linux-scsi@vger.kernel.org

On 10/20/2011 04:18 AM, Yathindra wrote:
> I'm trying to simulate a faulty disk behavior on linux. Basically, I
> want to inject various disk failure patterns
> such as medium errors, unresponsive disk etc.

If using a device-mapper device is acceptable for your purpose there are 
the dm-flakey and dm-delay targets that can add delays, drop and corrupt 
writes and introduce intermittent I/O errors.

The targets can be stacked to give devices having any combination of 
these behaviours.

Regards,
Bryn.
