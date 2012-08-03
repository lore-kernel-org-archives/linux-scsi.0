From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH v4 4/7] scsi: sr: block events when runtime suspended
Date: Fri, 03 Aug 2012 10:52:34 -0400
Message-ID: <501BE5B2.5040901@pobox.com>
References: <1343379650-2867-1-git-send-email-aaron.lu@amd.com> <1343379650-2867-5-git-send-email-aaron.lu@amd.com> <501B9EE7.1080000@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <501B9EE7.1080000@amd.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@amd.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Sergei Shtylyov <sshtylyov@mvista.com>, Oliver Neukum <oneukum@suse.de>, Jeff Wu <jeff.wu@amd.com>, Lin Ming <minggr@gmail.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On 08/03/2012 05:50 AM, Aaron Lu wrote:
> Hello,
>
> Not sure if I should use EXPORT_SYMBOL or EXPORT_SYMBOL_GPL, any
> comments?

Typically you follow the pattern of similar exports in the file (or in 
the API, if no others are in the file).

	Jeff





