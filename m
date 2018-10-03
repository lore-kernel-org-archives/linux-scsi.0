From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 09/16] scsi: Replace spin_is_locked() with lockdep
Date: Wed, 3 Oct 2018 06:53:19 -0700
Message-ID: <9c03e8e2-1fda-dd9e-2716-e45175111509@acm.org>
References: <20181003053902.6910-1-ldr709@gmail.com>
 <20181003053902.6910-10-ldr709@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181003053902.6910-10-ldr709@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Lance Roy <ldr709@gmail.com>, linux-kernel@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>, Karan Tilak Kumar <kartilak@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/2/18 10:38 PM, Lance Roy wrote:
> lockdep_assert_held() is better suited to checking locking requirements,
> since it won't get confused when someone else holds the lock. This is
> also a step towards possibly removing spin_is_locked().

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
