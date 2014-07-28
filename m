From: =?ISO-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>
Subject: Re: [Xen-devel] [PATCH V2 3/4] Introduce XEN scsiback module
Date: Mon, 28 Jul 2014 05:35:34 +0200
Message-ID: <53D5C506.7070505@suse.com>
References: <1406288253-13293-1-git-send-email-jgross@suse.com>	<1406288253-13293-4-git-send-email-jgross@suse.com> <20140726152358.GA1854@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20140726152358.GA1854@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: target-devel@vger.kernel.org, JBottomley@parallels.com, linux-scsi@vger.kernel.org, xen-devel@lists.xen.org
List-Id: linux-scsi@vger.kernel.org

On 07/26/2014 05:23 PM, Christoph Hellwig wrote:
> Just a quick glance:
>
>   a) this should move to drivers/target with the other target code

I don't mind. I just followed the example of drivers/vhost/vhost.c and
thought the similar xen module should be located under drivers/xen.

>   b) you're still having your own CDB emulation in there, the target code
>      should be taking care of all that.

Okay, I'll remove the CDB emulation.


Juergen
