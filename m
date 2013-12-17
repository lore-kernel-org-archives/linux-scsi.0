From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 0/32] Refcounts and rbtrees to increase luns above 255
Date: Mon, 16 Dec 2013 18:03:43 -0800
Message-ID: <52AFB0FF.9000101@redhat.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>  <1387231426.20247.260.camel@haakon3.risingtidesystems.com>  <52AFADB3.3060101@redhat.com> <1387245542.20247.284.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1387245542.20247.284.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/16/2013 05:59 PM, Nicholas A. Bellinger wrote:

> I do appreciate the effort, but the extra pointer chasing here makes
> rbtrees prohibitively expensive for fast past operations.

Hmm, were they actually implemented and tried at some point?
