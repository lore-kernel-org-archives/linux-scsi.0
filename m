From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 3/3] target: Change some fabric functions to return bool
Date: Mon, 17 Nov 2014 14:58:06 -0800
Message-ID: <546A7D7E.7090808@redhat.com>
References: <1415911858-3123-1-git-send-email-agrover@redhat.com> <1415911858-3123-3-git-send-email-agrover@redhat.com> <20141114070604.GB3944@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20141114070604.GB3944@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, nab@linux-iscsi.org
List-Id: linux-scsi@vger.kernel.org

On 11/13/2014 11:06 PM, Christoph Hellwig wrote:
> On Thu, Nov 13, 2014 at 12:50:58PM -0800, Andy Grover wrote:
>> The tpg_check_* functions in the fabric_ops struct return 1 or 0,
>> so we can make their return type bool. Change fabrics to match.
>
> All these true/false stub sounds like some of them methods should be
> optional, and a useful default should be assumed if they aren't present.

This may be true but I couldn't determine a useful default, or a change 
that would make the code shorter or clearer, so I left it for now.

-- Andy
