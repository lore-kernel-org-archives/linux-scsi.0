From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCH] lpfc: fix oops/BUG in lpfc_sli_ringtxcmpl_put()
Date: Wed, 23 Nov 2016 13:39:54 -0200
Message-ID: <ca614364-c42f-0ff9-0775-ff2fc8b49ca2@linux.vnet.ibm.com>
References: <1479904399-19496-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <20161123141222.knkjbhzia6lr3orl@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161123141222.knkjbhzia6lr3orl@linux-x5ow.site>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/23/2016 12:12 PM, Johannes Thumshirn wrote:
> Looks good and sorry for the bug,
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

Thanks for the quick review. Not a problem!
This problem turned out to be a good learning exercise. :)


-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center
