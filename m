From: Yathindra <ydev@cs.utah.edu>
Subject: Re: Simulating faulty disk
Date: Thu, 20 Oct 2011 09:45:05 -0600
Message-ID: <4EA04201.1050702@cs.utah.edu>
References: <4E9F9321.8090704@cs.utah.edu> <4E9FE97E.4030209@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rio.cs.utah.edu ([155.98.64.241]:34790 "EHLO
	mail-svr1.cs.utah.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756356Ab1JTPpM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Oct 2011 11:45:12 -0400
In-Reply-To: <4E9FE97E.4030209@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bryn M. Reeves" <bmr@redhat.com>
Cc: linux-scsi@vger.kernel.org

Hi Bryn,

Thanks for that info. Could you please tell me where I can find more 
details about using it.

Thanks again,
Yathi

On 10/20/2011 3:27 AM, Bryn M. Reeves wrote:
> On 10/20/2011 04:18 AM, Yathindra wrote:
>> I'm trying to simulate a faulty disk behavior on linux. Basically, I
>> want to inject various disk failure patterns
>> such as medium errors, unresponsive disk etc.
>
> If using a device-mapper device is acceptable for your purpose there 
> are the dm-flakey and dm-delay targets that can add delays, drop and 
> corrupt writes and introduce intermittent I/O errors.
>
> The targets can be stacked to give devices having any combination of 
> these behaviours.
>
> Regards,
> Bryn.

