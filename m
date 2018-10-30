From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 11/14] irq: add support for allocating (and affinitizing)
 sets of IRQs
Date: Tue, 30 Oct 2018 11:33:51 -0600
Message-ID: <d393e6f3-bc45-e038-9a5e-e51018f0a15a@kernel.dk>
References: <20181029163738.10172-12-axboe@kernel.dk>
 <20181030142601.GA18906@localhost.localdomain>
 <c11c95ae-5e10-38bd-d2c2-e2407634f52a@kernel.dk>
 <20181030144527.GB18906@localhost.localdomain>
 <46dbcbcd-799f-9970-a68f-de7e96b1a6bb@kernel.dk>
 <20181030150840.GC18906@localhost.localdomain>
 <d049e764-b9d1-f06f-40d3-39517f3f65a2@kernel.dk>
 <20181030160242.GD18906@localhost.localdomain>
 <27c1017a-9560-80cb-038d-f64727a162c3@kernel.dk>
 <535480f3-9087-b4ae-e7c8-cfe3c2d1e2c9@kernel.dk>
 <20181030172234.GF18906@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181030172234.GF18906@localhost.localdomain>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

On 10/30/18 11:22 AM, Keith Busch wrote:
> On Tue, Oct 30, 2018 at 11:09:04AM -0600, Jens Axboe wrote:
>> Pretty trivial, below. This also keeps the queue mapping calculations
>> more clean, as we don't have to do one after we're done allocating
>> IRQs.
> 
> Yep, this addresses my concern. It less efficient than PCI since PCI
> can usually jump straight to a valid vector count in a single iteration
> where this only subtracts by 1. I really can't be bothered to care for
> optimizing that, so this works for me! :) 

It definitely is less efficient than just getting the count that we
can support, but it's at probe time so I could not really be bothered
either.

Can I add your reviewed-by?

-- 
Jens Axboe
