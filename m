From: Joe Jin <joe.jin@oracle.com>
Subject: Re: [PATCH] [scsi] enclosure: remove all possible sysfs entries before
 add device
Date: Tue, 10 Sep 2013 09:50:44 +0800
Message-ID: <522E7AF4.9060504@oracle.com>
References: <522D685D.5060201@oracle.com> <20130909134131.GB24738@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130909134131.GB24738@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 09/09/13 21:41, Christoph Hellwig wrote:
>> Modules linked in: oracleacfs(P)(U) oracleadvm(P)(U) oracleoks(P)(U)
> 
> Please reproduce without this weird crap loaded.
> 
These modules is filesystem and will not impact enclosure.

Thanks,
Joe
